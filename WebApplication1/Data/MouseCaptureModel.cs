namespace WebApplication1.Data
{
    using System;
    using System.Data.Entity;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Linq;

    public partial class MouseCaptureModel : DbContext
    {
        public MouseCaptureModel()
            : base("name=MouseCaptureModel")
        {
        }

        public virtual DbSet<MouseCapture> MouseCaptures { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Entity<MouseCapture>()
                .Property(e => e.PageName)
                .IsUnicode(false);
        }
    }
}
