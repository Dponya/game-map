<?php
class Router {
    protected $routes = [];
    protected $middlewares = [];

    public function addRoute($route, $handler) {
        $this->routes[$route] = $handler;
    }

    public function addMiddleware($middleware) {
        $this->middlewares[] = $middleware;
    }

    public function match($url) {
        foreach ($this->routes as $route => $handler) {
            if ($url === $route) {
                return $handler;
            }
        }
        return null;
    }

    public function run() {
        if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
            header("Access-Control-Allow-Origin: *");
            header("Access-Control-Allow-Headers: *");
            header('Content-Type: application/json');
            exit;
          }
        header("Access-Control-Allow-Origin: *");
        header('Content-Type: application/json');
        $url = $_SERVER['REQUEST_URI'];
        $handler = $this->match($url);

        if ($handler) {
            $continue = true;
            foreach ($this->middlewares as $middleware) {
                $result = $middleware();
                if ($result !== null) {
                    $continue = false;
                    // return result of middleware
                    // echo $result;
                    break;
                }
            }
            if ($continue) {
                $handler();
            }
        } else {
            // return 404 error
            http_response_code(404);
            return "404 Not Found";
        }
    }
}
?>