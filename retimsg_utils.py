#!/usr/bin/env python3
"""
RetiMsg Utilities - Shared functions for retimsg client and daemon
"""

def clean_hash(hash_input):
    """Clean a hash from RNS format to plain hex string
    
    Handles both RNS.prettyhexrep output (with angle brackets) and raw strings.
    Returns lowercase hex string without formatting.
    Raises ValueError if input is None or empty.
    
    Args:
        hash_input: bytes, str, or RNS hash object
        
    Returns:
        str: Lowercase hex string without formatting
        
    Raises:
        ValueError: If input is None or empty
    """
    if hash_input is None:
        raise ValueError("Hash cannot be None")
    
    if isinstance(hash_input, bytes):
        return hash_input.hex()
    
    hash_str = str(hash_input).strip()
    if not hash_str:
        raise ValueError("Hash cannot be empty")
    
    return hash_str.replace("<", "").replace(">", "").replace(" ", "").lower()


# Security limits - centralized configuration
MAX_MESSAGE_SIZE = 1024 * 1024  # 1MB message limit
MAX_SOCKET_DATA = 2 * 1024 * 1024  # 2MB socket read limit
MAX_RESPONSE_SIZE = 2 * 1024 * 1024  # 2MB response limit
