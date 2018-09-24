# Handling Errors in Synchrony SDK

All SDK calls should return success or an exception. We've also added a service status endpoint that you can use to check whether it's an error in your code, or the service is experiencing issues.

To test the service, you can call `getStatus` or `printStatus`:

```julia
# Get the service status - should respond with 'UP!'
@show serviceStatus = getStatus()

# Print the service status.
printStatus()
```

We recommend catching the exceptions in service calls. That way, you can either bubble the exception further, or mask an error. The recommended approach for a robust SDK call is:

```julia
try
    robot = getRobot("IDONTEXIST")
catch ex
    println("Unable to get robot, error is:");
    showerror(STDERR, ex, catch_backtrace())
end
```

If you want to go further and use the return code to determine what to do (depending on whether it is a 401/403 authorization error or a 500 internal service error), you can use the exception status:

```julia
try
    robot = getRobot("IDONTEXIST")
catch ex
    println("Unable to get robot, error is:");
    showerror(STDERR, ex, catch_backtrace())
    println()
    if ex.status == 500
        warn("It's an internal service error, please confirm that 'IDONTEXIST' exists :)")
    elseif ex.status == 401 || ex.status == 403
        warn("It's an authorization error, please check your credentials")
    end
end
```
