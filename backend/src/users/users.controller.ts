import { Controller, Get, Query } from '@nestjs/common';
import { UsersServices } from './users.services';

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersServices) {}

  @Get()
  async getAllUsers() {
    return await this.usersService.getUsers();
  }

  @Get('without')
  async getUsersWithoutEmail(@Query('email') email: string) {
    return await this.usersService.getUsersWithoutEmail(email);
  }
}