<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // For SQLite, we just need to clean the data
        DB::table('users')->where('role', 'attandee')->update(['role' => 'attendee']);

        // Ensure all roles are either 'admin' or 'attendee'
        DB::table('users')->whereNotIn('role', ['admin', 'attendee'])->update(['role' => 'attendee']);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('role')->default('attendee')->change();
        });
    }
};
