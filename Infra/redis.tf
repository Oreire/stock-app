/* resource "aws_elasticache_cluster" "stock_redis" {
  cluster_id           = "stock-redis"
  engine               = "redis"
  engine_version       = "5.0"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.stock_redis_params.name
}

resource "aws_elasticache_parameter_group" "stock_redis_params" {
  name   = "stock-redis-params"
  family = "redis5.0"
  
  parameter {
    name  = "maxmemory-policy"
    value = "allkeys-lru"
  }
}
 */