<?php

use App\Libraries\Settings;

if (!function_exists('get_setting')) {
    function get_setting($key)
    {
        static $settings = null;

        if ($settings === null) {
            $settings = new Settings();
        }

        return $settings->getInfo()[$key] ?? null;
    }
}
