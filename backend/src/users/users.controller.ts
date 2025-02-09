import { Controller, Get, Query } from '@nestjs/common';
import { UsersService } from './users.service';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  async getAllUsers() {
    return await this.usersService.getUsers();
  }

  @Get('user')
  async getUserById(@Query('userId') userId: string) {
    return await this.usersService.getUserById(userId);
  }

  @Get('without')
  async getUsersWithoutEmail(@Query('email') email: string) {
    return await this.usersService.getUsersWithoutEmail(email);
  }
}