<?php
include 'router.php';

// map generation DSL

// Entity can be constructed by passing cords x & y to constructor
class Entity {
  public $x;
  public $y;

  public function __construct($x, $y) {
    $this->x = $x;
    $this->y = $y;
    return $this;
  }
}

// GameMap stores entities and can be constructed with passed size of map (size * size)
class GameMap {
  public $size;
  public $entities = [];

  public function __construct($size, $entities) {
    $this->entities = $entities;
    $this->size = $size;
    return $this;
  }
}

function generateMap() {

  function generateEntities() {
    $entityCount = rand(5, 25);
    $entities = [];
    for ($i=0; $i < $entityCount; $i++) { 
      $entities[] = new Entity(rand(0, 500), rand(0, 500));
    }

    return $entities;
  }

  $gameMap = new GameMap(500, generateEntities());

  return $gameMap;
}

// run application
$router = new Router();

$router->addRoute('/', function() {
  $generated = json_encode(generateMap());
  echo $generated;
});

$router->addMiddleware(function () {
  $headers = getallheaders();
  if (isset($headers['Token']) && $headers['Token'] === "12345") {
    return null;
  } else {
      http_response_code(401);
      echo "right token isn't there";
      return true;
  }
});

$router->run();
?>