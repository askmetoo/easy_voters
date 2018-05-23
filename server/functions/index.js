/**
 * Copyright 2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
"use strict";

const functions = require("firebase-functions");
const nodemailer = require("nodemailer");
// Configure the email transport using the default SMTP transport and a GMail account.
// For Gmail, enable these:
// 1. https://www.google.com/settings/security/lesssecureapps
// 2. https://accounts.google.com/DisplayUnlockCaptcha
// For other types of transports such as Sendgrid see https://nodemailer.com/transports/
// TODO: Configure the `gmail.email` and `gmail.password` Google Cloud environment variables.
const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;
const mailTransport = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword
  }
});

// Your company name to include in the emails
// TODO: Change this to your app or company name to customize the email sent.
const APP_NAME = "Easy Voters";

// [START sendWelcomeEmail]
/**
 * Sends a welcome email to new user.
 */
// [START onCreateTrigger]

exports.sendEmail = functions.https.onRequest((req, res) => {
  // [END onCreateTrigger]
  // [START eventAttributes]
  const id = req.query.id;
  const email = req.query.email; // The email of the user.
  // [END eventAttributes]

  sendEmail(email, id);

  return res.send("success!");
});

exports.sendReport = functions.https.onRequest((req, res) => {
  const id = req.query.id;
  const email = "nathanallencooper@gmail.com";

  sendReport(email, id);

  return res.send("success!");
});

// Sends a welcome email to the given user.
function sendEmail(email, id) {
  const mailOptions = {
    from: `${APP_NAME} <noreply@firebase.com>`,
    to: email
  };

  // The user subscribed to the newsletter.
  mailOptions.subject = `${APP_NAME}: Survey Invite!`;
  mailOptions.text = `Hello from ${APP_NAME}!\n
  You have been invited to vote on a survey. Here is the survey's ID: ${id}.\n\n
  If you don't have the EasyVoters app already, download it from the Google Play Store.`;
  return mailTransport.sendMail(mailOptions).then(() => {
    return console.log("New welcome email sent to:", email);
  });
}

// Sends a welcome email to the given user.
function sendReport(email, id) {
  const mailOptions = {
    from: `${APP_NAME} <noreply@firebase.com>`,
    to: email
  };

  // The user subscribed to the newsletter.
  mailOptions.subject = `${APP_NAME}: Report of Survey!`;
  mailOptions.text = `Hello from ${APP_NAME}!\n
  The following survey's ID has been reported: ${id}.`;
  return mailTransport.sendMail(mailOptions).then(() => {
    return console.log("New welcome email sent to:", email);
  });
}
