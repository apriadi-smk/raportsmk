<?php

use Firebase\JWT\JWT;
use Firebase\JWT\Key;

if (!function_exists('getJwtSecret')) {
    function getJwtSecret()
    {
        $config = new \Config\Jwt(); // Gunakan namespace langsung
        return $config->secretKey;
    }
}

if (!function_exists('createJWT')) {
    function createJWT($payload, $expiry = 3600)
    {
        $issuedAt = time();
        $expirationTime = $issuedAt + $expiry;

        $payload['iat'] = $issuedAt; // Issued at
        $payload['exp'] = $expirationTime; // Expiration time

        return JWT::encode($payload, getJwtSecret(), 'HS256');
    }
}
 
if (!function_exists('validateJWT')) {
    function validateJWT($token)
    {
        try {
            return JWT::decode($token, new Key(getJwtSecret(), 'HS256')); // Hasilnya objek
        } catch (\Firebase\JWT\ExpiredException $e) {
            return ['error' => 'Token sudah expired']; // Pastikan error sebagai array
        } catch (\Exception $e) {
            return ['error' => 'Token tidak valid'];
        }
    }
}
