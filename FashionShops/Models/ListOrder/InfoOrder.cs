using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models.ListOrder
{
    public class InfoOrder
    {
        public long order_id { get; set; }
        public long customer_id { get; set; }
        public System.DateTime order_date { get; set; }
        public double original_price { get; set; }
        public Nullable<double> reduced_price { get; set; }
        public double total_price { get; set; }
        public Nullable<long> voucher_id { get; set; }
        public string order_status { get; set; }
        public Nullable<double> transport_fee { get; set; }
        public int firtProductID{ get; set; }
    }
}