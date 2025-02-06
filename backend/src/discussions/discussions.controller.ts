import { Controller, Get, Post, Body } from '@nestjs/common';
import { DiscussionsService } from './discussions.services';

@Controller('discussions')
export class DiscussionsController {
  constructor(private readonly discussionsService: DiscussionsService) {}

  @Post()
  async createOrGetDiscussion(@Body('usersIds') usersIds: string[]) {
    return await this.discussionsService.createOrGetDiscussion(usersIds);
  }
  @Get()
  async getAllDiscussions() {
    return await this.discussionsService.getDiscussions();
  }
}
