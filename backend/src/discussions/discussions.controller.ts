import { Controller, Get, Post, Body, Query } from '@nestjs/common';
import { DiscussionsService } from './discussions.service';

@Controller('discussions')
export class DiscussionsController {
  constructor(private readonly discussionsService: DiscussionsService) {}

  @Get()
  async getAllDiscussions() {
    return await this.discussionsService.getDiscussions();
  }
  @Get('user')
  async getDiscussionsOfUser(@Query('userId') userId: string) {
    return await this.discussionsService.getDiscussionsOfUser(userId);
  }

  @Post()
  async createOrGetDiscussion(@Body('usersIds') usersIds: string[]) {
    return await this.discussionsService.createOrGetDiscussion(usersIds);
  }
}
