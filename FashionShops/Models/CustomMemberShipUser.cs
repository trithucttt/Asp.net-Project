using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;

namespace FashionShops.Models
{
    public class CustomMembershipUser : MembershipUser
    {
        #region User Properties

        public int UserId { get; set; }
        public string Username { get; set; }

        #endregion

        public CustomMembershipUser(User user) : base("CustomMembershipProvider", user.username, user.user_id, user.email, string.Empty, string.Empty, true, false, DateTime.Now, DateTime.Now, DateTime.Now, DateTime.Now, DateTime.Now)
        {
            UserId = (int)user.user_id;
            Username = user.username;
        }
    }
}