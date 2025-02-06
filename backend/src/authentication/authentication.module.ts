import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { AuthenticationServices } from './authentication.services';
import { AuthenticationController } from './authentication.controller';
import { UsersModule } from '../users/users.module';
import { UsersServices } from '../users/users.services';

@Module({
  imports: [
    UsersModule,
    JwtModule.register({
      secret: 'topSecret51',
      signOptions: {
        expiresIn: 3600,
      },
    }),
    PassportModule.register({ defaultStrategy: 'jwt' }),
  ],
  controllers: [AuthenticationController],
  providers: [AuthenticationServices, UsersServices],
  exports: [PassportModule, JwtModule],
})
export class AuthenticationModule {}