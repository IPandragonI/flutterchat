import { Body, Controller, Get, Post, Query } from '@nestjs/common';
import { MessagesService } from './messages.service';
import { MessageDto } from './dto/message.dto';

@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {
  }

  @Get()
  async getAllMessagesFromDiscussion(@Query('discussionId') discussionId: string) {
    return await this.messagesService.getAllMessagesFromDiscussion(discussionId);
  }

  @Post()
  async createMessage(@Body() messageDto: MessageDto) {
    return await this.messagesService.insertMessage(messageDto);
  }
}