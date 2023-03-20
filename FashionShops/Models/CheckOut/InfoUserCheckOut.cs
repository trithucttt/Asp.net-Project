using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models.CheckOut
{
    public class InfoUserCheckOut
    {
        public long user_id { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string phoneNumber { get; set; }
        public string email { get; set; }
        public string province { get; set; }
        public string city { get; set; }
        public string country { get; set; }
        public string address { get; set; }
    }
}