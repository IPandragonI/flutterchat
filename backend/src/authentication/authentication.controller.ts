import { Controller, Post, Body } from '@nestjs/common';
import { AuthenticationServices } from './authentication.services';
import { AuthCredentialsDto } from './dto/auth-credentials.dto';
import { AuthCredentialsLoginDto } from './dto/auth-credentials-login.dto';

@Controller('auth')
export class AuthenticationController {
  constructor(private readonly authService: AuthenticationServices) {}

  @Post('signup')
  async signUp(@Body() authCredentialsDto: AuthCredentialsDto): Promise<void> {
    return this.authService.signUp(authCredentialsDto);
  }

  @Post('login')
  async login(@Body() authCredentialsLoginDto : AuthCredentialsLoginDto): Promise<{ accessToken: string }> {
    return this.authService.login(authCredentialsLoginDto);
  }
}