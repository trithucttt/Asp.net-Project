using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models.CartForModal
{
    public class AllNeedsForModal
    {
        public int cartID { get; set; }
        public int sizeActive { get; set; }
        public int colorActive { get; set; }
        public List<InfProForModal> infProduct { get; set; }
        public List<ColorsProForModal> colorsProduct { get; set; }
        public List<SizesProForModal> sizesProduct { get; set; }
    }
}