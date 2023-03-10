using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FashionShops.Models.CartForModal
{
    public class AllNeedsForModal
    {
        public List<InfProForModal> infProduct { get; set; }
        public List<ColorsProForModal> colorsProduct { get; set; }
        public List<SizesProForModal> sizesProduct { get; set; }
    }
}