defmodule CookbookWeb.ProgressLive do
  use CookbookWeb, :live_view

  @number_of_slow_function_calls 200

  def render(assigns) do
    ~H"""
    <div class="progress">
      <div class="progress-bar" role="progressbar" style={"width: #{@progress}%;"} aria-valuenow={@progress} aria-valuemin="0" aria-valuemax="100"><%= @progress %>%</div>
    </div>

    <div class="mt-5">
      <%= if @completed == 0 do %>
        <a href="#" phx-click="start-long-runnning_task" class="btn btn-success">Start long running task</a>
      <% else %>
        Completed <%= @completed %> of <%= @number_of_slow_function_calls %> slow function calls.
      <% end %>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    # Create a pubsub topic that is unique for this LiveView process
    task_topic = "task-" <> Ecto.UUID.generate
    Phoenix.PubSub.subscribe(Cookbook.PubSub, task_topic)

    {:ok,
     assign(socket,
       completed: 0,
       progress: 0,
       number_of_slow_function_calls: @number_of_slow_function_calls,
       task_topic: task_topic
     )}
  end

  def handle_event("start-long-runnning_task", _params, socket) do
    long_running_task(socket.assigns.task_topic)
    {:noreply, socket}
  end

  defp long_running_task(task_topic) do
    # Start another process to do the long running task
    Task.start(fn ->
      1..@number_of_slow_function_calls |> Enum.each(fn _ -> slow_function(task_topic) end)
    end)
  end

  defp slow_function(task_topic) do
    # Sleep between 10 and 50 ms to simulate a slow function
    10..50 |> Enum.random() |> Process.sleep()
    # Done - publish that the task is complete
    Phoenix.PubSub.broadcast(Cookbook.PubSub, task_topic, :completed)
  end

  def handle_info(:completed, socket) do
    # This function is called via pubsub every time a task is completed
    completed = socket.assigns.completed + 1
    progress = completed * 100 / @number_of_slow_function_calls
    {:noreply, assign(socket, completed: completed, progress: progress)}
  end
end
