<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\ApiResponse;
use App\Models\Event;
use App\Models\Ticket;
use Illuminate\Support\Facades\DB; 


class TicketController extends Controller
{
    use ApiResponse;

    public function store(Request $request, $eventId)
    {
        $event = Event::find($eventId);
        if(!$event){
            return $this->errorResponse('Event not found', 404);
        }

        $user =  $request->user();

        DB::beginTransaction();

        try {
            $event =  Event::where(
                'id', $eventId
            ) ->lockForUpdate()->firstOrFail();


            if($event->date < now()){
                DB::rollBack();
                return $this->errorResponse('Event already ended', 400);
            }

            $exisitingTicket =  Ticket::where('user_id',$user->id)->where('event_id',$eventId)->where('is_canceled',false)->exists();
        
        if($exisitingTicket){
            DB::rollBack();
            return $this->errorResponse('You already have a ticket for this event', 400);
        }

        $currentBookings = Ticket::where('event_id', $event->id)->where('is_canceled',false)->count();

        if($currentBookings >= $event->max_reservation){
            DB::rollBack();
            return $this->errorResponse('Event is full', 400);
        }
        
          

        $payload = [
            'un' => $user->id,
            'ue' => $user->email,
            'en' => $event->name,
            'ed' => $event->date,
            
        ];
            
        $endcode = base64_encode(json_encode($payload)); 
        //ikutan-xxxxxx-payload
        $code = 'ikutan-'.uniqid().'-'.$endcode;

        $ticket = Ticket::create([
            'user_id' => $user->id,
            'event_id' => $event->id,
            'code' => $code,
        ]);

        DB::commit();

        return $this->success($ticket, 'Ticket created successfully',201);
        }catch (\Exception $e) {
            DB::rollBack();
            
        }
    }

    public function indexByUser(Request $request){

      $user = $request->user();
      $tickets = $user->tickets()->latest()->get();
      return $this->success($tickets, 'Tickets retrieved successfully',200);
    }   

    public function indexByEvent(Request $request, $eventId){
        
        $event = Event::find($eventId);
        if(!$event){
            return $this->errorResponse('Event not found', 404);
        }

        $tickets = Ticket::where('event_id', $event->id)->where('is_canceled',false)->latest()->get();
        return $this->success($tickets, 'Tickets retrieved successfully',200);
    }

    public function cancel(Request $request, $ticketId){
        
        /** @var \App\Models\Ticket $ticket */
        $ticket = Ticket::find($ticketId);
        if(!$ticket){
            return $this->errorResponse('Ticket not found', 404);
        }

        if($ticket->is_canceled){
            return $this->errorResponse('Ticket is already canceled', 400);
        }
        if($ticket->check_in_at){
            return $this->errorResponse('Ticket already checked in', 400);
        }
        
        $ticket->is_canceled = true;
        $ticket->save();    

        return $this->success($ticket, 'Ticket canceled successfully', 200);
    }

    public function checkin(Request $request, $ticketId){

        $code = $request->code; 
        $ticket = Ticket::where('code', $code)->where('is_canceled',false)->first();
        if(!$ticket){
            return $this->errorResponse('Ticket not found', 404);
        }

        if($ticket->is_canceled){
            return $this->errorResponse('Ticket is canceled', 400);
        }
        if($ticket->check_in_at){
            return $this->errorResponse('Ticket already checked in', 400);
        }

        $ticket->check_in_at = now();
        $ticket->save();    

        return $this->success($ticket, 'Ticket checked in successfully', 200);
    }
}   

