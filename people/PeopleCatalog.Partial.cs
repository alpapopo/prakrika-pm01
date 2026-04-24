using System;
using System.IO;

namespace people
{
    public partial class Catalogs
    {
        public string CurrentPhoto
        {
            get
            {
                if (!string.IsNullOrWhiteSpace(PhotoPath))
                {
                    if (Path.IsPathRooted(PhotoPath) && File.Exists(PhotoPath))
                        return PhotoPath;

                    string inBinImages = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Images", PhotoPath);
                    if (File.Exists(inBinImages))
                        return inBinImages;

                    string inProjectImages = Path.GetFullPath(
                        Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "..", "..", "Images", PhotoPath));
                    if (File.Exists(inProjectImages))
                        return inProjectImages;
                }

                return "/Images/free-icon-shopping-cart-5087816.png";
            }
        }
    }
}

