using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(CarCoin.Startup))]
namespace CarCoin
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
