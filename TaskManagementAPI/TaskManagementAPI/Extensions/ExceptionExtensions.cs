using System;
using System.Collections.Generic;
using System.Linq;

namespace TaskManagementAPI.Extensions
{
    public static class ExceptionExtensions
    {

        public static T ThrowIfNull<T>(this T value, string message)
        {
            if (value == null)
            {
                throw new Exception(message);
            }
            return value;
        }
 
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
