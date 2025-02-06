import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { DiscussionSchema } from './discussion.model';
import { DiscussionsController } from './discussions.controller';
import { DiscussionsService } from './discussions.services';

@Module({
  imports: [MongooseModule.forFeature([{ name: 'Discussion', schema: DiscussionSchema }])],
  controllers: [DiscussionsController],
  providers: [DiscussionsService],
  exports: [MongooseModule],
})
export class DiscussionsModule {
}