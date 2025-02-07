import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { DiscussionSchema } from './discussion.model';
import { DiscussionsController } from './discussions.controller';
import { DiscussionsService } from './discussions.service';
import { UsersModule } from '../users/users.module';
import { UsersService } from '../users/users.service';

@Module({
  imports: [UsersModule, MongooseModule.forFeature([{ name: 'Discussion', schema: DiscussionSchema }])],
  controllers: [DiscussionsController],
  providers: [DiscussionsService, UsersService],
  exports: [MongooseModule],
})
export class DiscussionsModule {}