import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';

import { UsersModule } from './users/users.module';
import { AuthenticationModule} from './authentication/authentication.module';
import { DiscussionsModule } from './discussions/discussions.module';
import { MessagesModule } from './messages/messages.module';

@Module({
  imports: [
    MongooseModule.forRoot('mongodb://devroot:devroot@localhost:27017/flutterchat?authSource=admin'),
    UsersModule,
    AuthenticationModule,
    DiscussionsModule,
    MessagesModule
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}