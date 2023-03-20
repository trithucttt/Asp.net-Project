using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using FashionShops.Models.CheckOut;

namespace FashionShops.Models.CheckOut
{
    public class AllNeedForCheckOut
    {
        public InfoUserCheckOut infoUserCheckOut { get; set; }
        public List<VoucherAvailable> voucherAvailable { get; set; }
        public List<PaymentMethods> paymentMethods { get; set; }

    }
}