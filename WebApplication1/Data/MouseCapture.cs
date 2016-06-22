namespace WebApplication1.Data
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    public partial class MouseCapture
    {
        public int Id { get; set; }

        public string PageName { get; set; }

        public double? X { get; set; }

        public double? Y { get; set; }

        public DateTime AddDate { get; set; }
    }
}
