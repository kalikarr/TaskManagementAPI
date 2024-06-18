using Microsoft.IdentityModel.Tokens;
using System;
using System.Configuration;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Cors;
using TaskManagementAPI.Data;
using TaskManagementAPI.Data.Dto;
using TaskManagementAPI.Extensions;
using TaskManagementAPI.Helpers;
using TaskManagementAPI.Models;

namespace TaskManagementAPI.Controllers
{
    /// <summary>
    /// Account controller Actions with User data
    /// </summary>
    /// <seealso cref="System.Web.Http.ApiController" />
    [EnableCors(origins: "*", headers: "*", methods: "*")]
    [RoutePrefix("api/account")]
    public class AccountController : ApiController
    {
        private readonly UserRepository _userRepository;
        private readonly string _jwtSecret = ConfigurationManager.AppSettings["JwtSecretkey"];
        private readonly int _jwtLifespan = Convert.ToInt16(ConfigurationManager.AppSettings["JwtTokenLifeInMinitue"]);

        #region Action Methods
        /// <summary>
        /// Initializes a new instance of the <see cref="AccountController"/> class.
        /// </summary>
        public AccountController()
        {
            _userRepository = new UserRepository();
        }

        /// <summary>
        /// Logins the specified login.
        /// </summary>
        /// <param name="login">The login.</param>
        /// <returns></returns>
        /// <exception cref="login">Login Model cannot be null</exception>
        [HttpPost, Route("login")]
        public async Task<IHttpActionResult> Login(LoginModel login)
        {
            try
            {
                login.ThrowIfNull("Login Model cannot be null");

                var user = await _userRepository.AuthenticateUserAsync(login.UserName, login.Password);
                if (user != null)
                {
                    var token = GenerateJwtToken(user);
                    return Json(new { Token = token, UserId = user.UserId, FullName = user.FullName });

                }
                return Unauthorized();
            }
            catch (Exception exc)
            {
                exc.HandleError();
                return Unauthorized();
            }
        }

        /// <summary>
        /// Getalls the task status.
        /// </summary>
        /// <returns></returns>
        [HttpGet, Route("getallusers")]
        public async Task<IHttpActionResult> GetallTaskStatus()
        {
            try
            {
                var allUsers = await _userRepository.GetAllUsersAsync();

                return Json(allUsers);

            }
            catch (Exception exc)
            {
                exc.HandleError();
                return BadRequest("Unable to fetch the users");
            }

        }
        #endregion

        #region Private Methods
        /// <summary>
        /// Generates the JWT token.
        /// </summary>
        /// <param name="user">The user.</param>
        /// <returns></returns>
        private string GenerateJwtToken(UserDto user)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_jwtSecret);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new[]
                {
                    new Claim(ClaimTypes.Name, user.UserName),
                    new Claim(ClaimTypes.NameIdentifier, user.UserId.ToString())
                }),
                Expires = DateTime.UtcNow.AddMinutes(_jwtLifespan),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }
        #endregion

    }
}
