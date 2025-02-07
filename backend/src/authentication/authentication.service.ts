import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { AuthCredentialsDto } from './dto/auth-credentials.dto';
import { UsersService } from '../users/users.service';
import * as bcrypt from 'bcrypt';
import { AuthCredentialsLoginDto } from './dto/auth-credentials-login.dto';

@Injectable()
export class AuthenticationService {
  constructor(
    private jwtService: JwtService,
    private usersService: UsersService,
  ) {}

  async signUp(authCredentialsDto: AuthCredentialsDto): Promise<void> {
    const { firstName, lastName, email, password } = authCredentialsDto;
    const alreadyExists = await this.usersService.checkUserAlreadyExists(email);
    if(alreadyExists) {
      throw new UnauthorizedException('Email already exists');
    } else {
      const hashedPassword = await bcrypt.hash(password, 10);
      await this.usersService.insertUser(firstName, lastName, email, hashedPassword, '');
    }
  }

  async login(authCredentialsLoginDto: AuthCredentialsLoginDto): Promise<{ accessToken: string, user: any }> {
    const { email, password } = authCredentialsLoginDto;
    const user = await this.usersService.getUser(email);

    if (user && (await bcrypt.compare(password, user.password))) {
      const payload = { email };
      const accessToken = this.jwtService.sign(payload);
      return { accessToken, user };
    } else {
      throw new UnauthorizedException('Invalid credentials');
    }
  }
}