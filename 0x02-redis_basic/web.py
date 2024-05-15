#!/usr/bin/env python3
""" expiring web cache module """


import requests
import redis
from functools import wraps
from typing import Callable

# Initialize Redis client
cache = redis.Redis()


def get_page(url: str) -> str:
    """
    Fetches the HTML content of a particular URL and caches the result.
    Tracks how many times a particular URL was accessed.
    """
    # Check if the URL is in the cache
    cached_page = cache.get(f"cached:{url}")
    if cached_page:
        return cached_page.decode('utf-8')

    # Fetch the page content
    response = requests.get(url)
    html_content = response.text

    # Cache the page content with an expiration time of 10 seconds
    cache.setex(f"cached:{url}", 10, html_content)

    # Increment the access count for the URL
    cache.incr(f"count:{url}")

    return html_content


def cache_page(func: Callable) -> Callable:
    @wraps(func)
    def wrapper(url: str) -> str:
        cached_page = cache.get(f"cached:{url}")
        if cached_page:
            return cached_page.decode('utf-8')

        html_content = func(url)
        cache.setex(f"cached:{url}", 10, html_content)
        cache.incr(f"count:{url}")

        return html_content
    return wrapper


@cache_page
def get_page_with_decorator(url: str) -> str:
    """
    Fetches the HTML content of a particular URL and caches the result.
    Tracks how many times a particular URL was accessed.
    Uses a decorator for caching.
    """
    response = requests.get(url)
    return response.text


# If you want to test the function directly, you can use:
if __name__ == "__main__":
    url = 'http://slowwly.robertomurray.co.uk/delay/3000/url/http://www.example.com'
    print(get_page(url))  # First call will fetch and cache the content
    print(get_page(url))  # Second call will retrieve the content from cache

    print(get_page_with_decorator(url))  # Using the decorated version
    # Second call will retrieve the content from cache
    print(get_page_with_decorator(url))
