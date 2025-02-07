import { Body, Controller, Get, Post } from '@nestjs/common';
import { MessagesService } from './messages.service';

@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Post()
  async createMessage(@Body('chatRoomId') chatRoomId: string, @Body('content') content: string, @Body('sender') sender: string) {
    return await this.messagesService.insertMessage(chatRoomId, content, sender);
  }
}