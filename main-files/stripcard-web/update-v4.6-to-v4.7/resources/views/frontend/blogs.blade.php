@extends('frontend.layouts.master')



@section('content')

@forelse ($page_section->sections ?? [] as $item)
        @php
            $component_name = 'frontend.sections.' .$item->section->key;
        @endphp
        @if(View::exists($component_name))
            @include($component_name)
        @endif
    @empty
        @include('frontend.sections.demo')
    @endforelse

@endsection


@push("script")

@endpush
