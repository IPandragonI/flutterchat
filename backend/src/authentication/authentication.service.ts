import { Injectable, UnauthorizedException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { JwtService } from '@nestjs/jwt';
import { AuthCredentialsDto } from './dto/auth-credentials.dto';
import { User } from '../users/user.model';
import { UsersService } from '../users/users.service';
import * as bcrypt from 'bcrypt';
import { AuthCredentialsSignInDto } from './dto/auth-credentials-signup.dto';

@Injectable()
export class AuthenticationService {
  constructor(
    @InjectModel('User') private userModel: Model<User>,
    private jwtService: JwtService,
    private usersService: UsersService,
  ) {}

  async signUp(authCredentialsDto: AuthCredentialsDto): Promise<void> {
    const { firstName, lastName, email, password } = authCredentialsDto;
    const hashedPassword = await bcrypt.hash(password, 10);
    await this.usersService.insertUser(firstName, lastName, email, hashedPassword, '');
  }

  async signIn(authCredentialsSignInDto: AuthCredentialsSignInDto): Promise<{ accessToken: string, userId: string }> {
    const { email, password } = authCredentialsSignInDto;
    const user = await this.userModel.findOne({ email });

    if (user && (await bcrypt.compare(password, user.password))) {
      const payload = { email };
      const accessToken = this.jwtService.sign(payload);
      const userId = String(user._id);
      return { accessToken, userId };
    } else {
      throw new UnauthorizedException('Invalid credentials');
    }
  }
}