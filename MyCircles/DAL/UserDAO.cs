﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Helpers;
using MyCircles.BLL;

namespace MyCircles.DAL
{
    public class UserDAO
    {
        public void AddUser(User newUser)
        {
            using (var db = new MyCirclesEntityModel())
            {
                if (String.IsNullOrEmpty(newUser.Password))
                {
                    throw new ArgumentException("Required fields are not filled up");
                }
                else
                {
                    if (db.Users.Any(u => u.Username == newUser.Username))
                    {
                        throw new ArgumentException("That username is not available");
                    }

                    if (db.Users.Any(u => u.EmailAddress == newUser.EmailAddress))
                    {
                        throw new ArgumentException("There's an account registered with that email");
                    }

                    newUser.Password = Crypto.HashPassword(newUser.Password);
                    db.Users.Add(newUser);
                    db.SaveChanges();
                }
            }
        }

        public User VerifyCredentials(string identfier, string password)
        {
            User testUser = new User();
            User user = new User();

            testUser.EmailAddress = identfier;
            testUser.Username = identfier;
            testUser.Password = password;

            using (MyCirclesEntityModel db = new MyCirclesEntityModel())
            {
                user = db.Users
                        .Where(u => u.Username == testUser.Username || u.Username == testUser.Username)
                        .FirstOrDefault();

                Console.WriteLine(user);

                if (user != null)
                {
                    if (!Crypto.VerifyHashedPassword(user.Password, testUser.Password))
                    {
                        user = null;
                        throw new ArgumentException("That password is not correct");
                    }

                }
                else
                {
                    throw new ArgumentException("That account does not exist");
                }
            }

            return user;
        }
    }
}