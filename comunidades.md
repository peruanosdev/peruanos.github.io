---
title: Meetups Locales Por Ciudad
---

<dl>
{% assign cities = site.data.communities | group_by:"city" %}
{% for city in cities %}
  <dt>{{ city.name }}</dt>
  <dd>
    <ul>
      {% for community in city.items %}
        <li>
          <a href="{{ community.url }}" target="_blank">
            {{ community.name }}
          </a>
          <a href="{{ community.url }}/events/rss" target="_blank" title="Feed de eventos de {{ community.name }}">
            <img src="https://img.icons8.com/office/16/000000/rss--v1.png">
          </a>
          <a href="{{ community.url }}/events/ical" target="_blank" title="Calendario de eventos de {{ community.name }}">
            <img src="https://img.icons8.com/office/16/000000/calendar-plus.png">
          </a>
        </li>
      {% endfor %}
    </ul>
  </dd>
{% endfor %}
</dl>