import { InjectModel } from '@nestjs/mongoose';
import mongoose, { Model } from 'mongoose';
import { Message } from './message.model';

export class MessagesService {
  constructor(@InjectModel('Message') private readonly messageModel: Model<Message>) {
  }

  async insertMessage(chatRoomId: string, content: string, sender: string) {
    const newMessage = new this.messageModel({
      chatRoomId,
      content,
      sender,
      date: new Date(),
      seenBy: [],
    });
    const result = await newMessage.save();
    return result.id as string;
  }

  async getMessages(chatRoomId: string) {
    const messages = await this.messageModel.find({ chatRoomId }).exec();
    return messages.map(message => ({
      id: message.id,
      chatRoomId: message.chatRoomId,
      content: message.content,
      sender: message.sender,
      date: message.date,
      seenBy: message.seenBy,
    }));
  }
}