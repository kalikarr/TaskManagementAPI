
using Microsoft.IdentityModel.Tokens;
using System.Configuration;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Http;
using System.Web.Http.Controllers;
namespace TaskManagementAPI.Filter
{
    public class JwtAuthorizeAttribute : AuthorizeAttribute
    {
        private readonly string _jwtSecret = ConfigurationManager.AppSettings["JwtSecretkey"];

        protected override bool IsAuthorized(HttpActionContext actionContext)
        {
            var authorizationHeader = actionContext.Request.Headers.Authorization;
            if (authorizationHeader != null && authorizationHeader.Scheme == "Bearer")
            {
                var token = authorizationHeader.Parameter;
                if (ValidateToken(token))
                {
                    var claimsPrincipal = GetPrincipal(token);
                    if (claimsPrincipal != null)
                    {
                        Thread.CurrentPrincipal = claimsPrincipal;
                        if (HttpContext.Current != null)
                        {
                            HttpContext.Current.User = claimsPrincipal;
                        }
                        return true;
                    }
                }
            }
            return false;
        }

        private bool ValidateToken(string token)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_jwtSecret);
            try
            {
                tokenHandler.ValidateToken(token, new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = false,
                    ValidateAudience = false
                }, out SecurityToken validatedToken);
            }
            catch
            {
                return false;
            }
            return true;
        }

        private ClaimsPrincipal GetPrincipal(string token)
        {
            try
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes(_jwtSecret);
                var tokenValidationParameters = new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = new SymmetricSecurityKey(key),
                    ValidateIssuer = false,
                    ValidateAudience = false
                };

                SecurityToken securityToken;
                var principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out securityToken);
                return principal;
            }
            catch
            {
                return null;
            }
        }
    }
}