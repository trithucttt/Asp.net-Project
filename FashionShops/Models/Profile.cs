using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models
{
    public class Profile
    {
        public int userId { get; set; }
        public string firstname { get; set; }
        public string lastname { get; set; }
        public string phonenumber { get; set; }
        public string email { get; set; }
        public string username { get; set; }
        public string address { get; set; }
        public string province { get; set; }
        public string city { get; set; }
        public string country { get; set; }
    }
}