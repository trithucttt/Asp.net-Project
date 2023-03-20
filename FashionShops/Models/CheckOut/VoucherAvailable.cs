using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models.CheckOut
{
    public class VoucherAvailable
    {
        public long voucher_id { get; set; }
        public string code { get; set; }
        public double discount_percentage { get; set; }
        public string voucher_status { get; set; }
        public System.DateTime start_date { get; set; }
        public System.DateTime end_date { get; set; }
    }
}