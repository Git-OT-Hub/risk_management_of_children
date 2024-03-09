// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import CommentImageController from "./comment_image_controller"
application.register("comment-image", CommentImageController)

import CommentReplyImageController from "./comment_reply_image_controller"
application.register("comment-reply-image", CommentReplyImageController)

import DiagnosisQuestionsController from "./diagnosis_questions_controller"
application.register("diagnosis-questions", DiagnosisQuestionsController)

import FileUploadController from "./file_upload_controller"
application.register("file-upload", FileUploadController)

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import TooltipController from "./tooltip_controller"
application.register("tooltip", TooltipController)

import UserAvatarController from "./user_avatar_controller"
application.register("user-avatar", UserAvatarController)
