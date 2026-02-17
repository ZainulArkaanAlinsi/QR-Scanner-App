<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        User::create([
            'name' => 'AdminArkaan',
            'email' => 'admin@gmail.com',
            'password' => bcrypt('1234567890'),
            'role' => 'admin',
        ]);
    }
}
