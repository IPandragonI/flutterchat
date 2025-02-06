import { Controller, Get, Post, Query } from '@nestjs/common';
import { DiscussionsService } from './discussions.services';

@Controller('discussions')
export class DiscussionsController {
  constructor(private readonly discussionsService: DiscussionsService) {}

  @Post()
  async createOrGetDiscussion(@Query('users') users: string[]) {
    return await this.discussionsService.createOrGetDiscussion(users);
  }
  @Get()
  async getAllDiscussions() {
    return await this.discussionsService.getDiscussions();
  }
}
