using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;

namespace WebApplication1.Controllers
{
    public class HomeController : AsyncController
    {
        Data.MouseCaptureModel _model = new Data.MouseCaptureModel();

        public ActionResult Index()
        {
            ViewBag.Title = "Home Page";
            return View();
        }

        [HttpPost]
        public async Task CaptureMouse(double X, double Y)
        { 
            _model.MouseCaptures.Add(new Data.MouseCapture { PageName = "Home", X = X, Y = Y, AddDate = DateTime.Today });
            await _model.SaveChangesAsync();
            //return await Task.Run(() => string.Empty);
        }
    }
}
