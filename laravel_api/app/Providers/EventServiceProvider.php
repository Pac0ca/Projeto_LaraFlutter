<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;

class EventServiceProvider extends ServiceProvider
{
    /**
     * Os eventos e seus listeners.
     *
     * @var array
     */
    protected $listen = [
        // Exemplo:
        // 'App\Events\SomeEvent' => [
        //     'App\Listeners\EventListener',
        // ],
    ];

    /**
     * Registra qualquer evento para sua aplicação.
     */
    public function boot(): void
    {
        //
    }
}
