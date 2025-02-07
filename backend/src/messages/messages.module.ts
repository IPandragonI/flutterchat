import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { MessageSchema } from './message.model';
import { MessagesController } from './messages.controller';
import { MessagesService } from './messages.service';
import { UsersModule } from '../users/users.module';
import { UsersService } from '../users/users.service';

@Module({
  imports: [UsersModule, MongooseModule.forFeature([{ name: 'Message', schema: MessageSchema }])],
  controllers: [MessagesController],
  providers: [MessagesService, UsersService],
  exports: [MongooseModule],
})
export class MessagesModule {}