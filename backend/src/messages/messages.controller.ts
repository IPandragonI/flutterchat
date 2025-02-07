import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { MessagesService } from './messages.service';

@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Get()
  async getAllMessagesFromDiscussion(@Query('discussionId') discussionId: string) {
    return await this.messagesService.getAllMessagesFromDiscussion(discussionId);
  }
  
  @Post()
  async createMessage(@Body('discussionId') discussionId: string, @Body('content') content: string, @Body('sender') sender: string) {
    return await this.messagesService.insertMessage(discussionId, content, sender);
  }
}