from fastapi import FastAPI, HTTPException, Query

app = FastAPI()

@app.get("/hello")
# takes a query parameter name
async def hello(name: str = None):
    # If name is not provided, or is an empty string, 
    # raise an HTTPException with a status code of 400
    if name is None or name == "":
        raise HTTPException(status_code=422, detail="name query parameter is required")
    # Returns a properly formatted JSON string of "message": "hello [VALUE]"
    return { "message": f"hello {name}" }