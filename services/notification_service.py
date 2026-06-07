def contact_service(service_name):

    print(
        f"Calling {service_name}..."
    )

    print(
        "Dialing: 9353571382"
    )

    return {
        "service": service_name,
        "contacted": True,
        "number": "9353571382"
    }