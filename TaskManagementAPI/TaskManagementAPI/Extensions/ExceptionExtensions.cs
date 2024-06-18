using System;

namespace TaskManagementAPI.Extensions
{
    /// <summary>
    /// Exception Extention Static Class
    /// </summary>
    public static class ExceptionExtensions
    {
        /// <summary>
        /// Throws if null.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value">The value.</param>
        /// <param name="message">The message.</param>
        /// <returns></returns>
        /// <exception cref="System.Exception"></exception>
        public static T ThrowIfNull<T>(this T value, string message)
        {
            if (value == null)
            {
                throw new Exception(message);
            }
            return value;
        }

        /// <summary>
        /// Throws if.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="value">The value.</param>
        /// <param name="test">The test.</param>
        /// <param name="message">The message.</param>
        /// <returns></returns>
        /// <exception cref="System.ArgumentException"></exception>
        public static T ThrowIf<T>(this T value, Predicate<T> test, string message)
        {
            if (test(value))
            {
                throw new ArgumentException(message);
            }
            return value;
        }

    }
}
