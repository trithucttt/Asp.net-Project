using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace FashionShops.Code
{
    public class Encrypt
    {
        public static string HashPassword(string input)
        {
            using (var md5 = new MD5CryptoServiceProvider())
            {
                var inputBytes = Encoding.UTF8.GetBytes(input);
                var hashBytes = md5.ComputeHash(inputBytes);
                var hash = BitConverter.ToString(hashBytes).Replace("-", "").ToLower();
                return hash;
            }
            //    return Convert.ToBase64String(
            //        System.Security.Cryptography.SHA256.Create().ComputeHash(Encoding.UTF8.GetBytes(input))
            //        );
        }

        public static bool VerifyMD5Hash(string input, string hash)
        {
            var hashOfInput = HashPassword(input);
            var comparer = StringComparer.OrdinalIgnoreCase;
            return comparer.Compare(hashOfInput, hash) == 0;
        }
    }
}